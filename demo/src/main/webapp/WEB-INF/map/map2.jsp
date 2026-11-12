
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카카오맵 장소 검색</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <!-- 카카오맵 API -->
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=70a38a244a850ec49100c42962a80b5b&libraries=services"></script>

    <style>
        #map {
            width: 700px;
            height: 450px;
        }

        #placesList {
            padding: 0;
            list-style: none;
            width: 700px;
        }

        .item {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }

        .item:hover {
            background-color: #f5f5f5;
        }

        .info h5 {
            margin: 0 0 5px;
        }

        .gray {
            color: gray;
            font-size: 12px;
        }

        .tel {
            display: block;
            margin-top: 5px;
            color: #666;
        }

        #pagination {
            margin: 15px 0;
        }

        #pagination a {
            padding: 5px 8px;
            cursor: pointer;
        }

        #pagination .on {
            color: red;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div id="app">

    <h2>카카오맵 장소 검색</h2>

    <!-- 검색창 -->
    <input type="text"
           v-model="keyword"
           @keyup.enter="searchPlaces"
           placeholder="검색할 장소를 입력하세요">

    <button type="button" @click="searchPlaces">
        검색
    </button>

    <!-- 지도 -->
    <div id="map"></div>

    <!-- 검색 결과 목록 -->
    <ul id="placesList"></ul>

    <!-- 페이지 번호 -->
    <div id="pagination"></div>

</div>

<script>
const app = Vue.createApp({

    data() {
        return {
            keyword: '',
            map: null,
            ps: null,
            infowindow: null,
            markers: []
        };
    },

    methods: {

        // 지도 초기화
        fnList: function () {

            let self = this;

            let mapContainer = document.getElementById('map');

            let mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                level: 3
            };

            // 지도 생성
            self.map = new kakao.maps.Map(mapContainer, mapOption);

            // 장소 검색 객체
            self.ps = new kakao.maps.services.Places();

            // 인포윈도우
            self.infowindow = new kakao.maps.InfoWindow({
                zIndex: 1
            });

        },

        // 장소 검색
        searchPlaces: function () {

            let self = this;

            let keyword = self.keyword.trim();

            if (!keyword) {
                alert('키워드를 입력해주세요!');
                return;
            }

            self.ps.keywordSearch(keyword, function(data, status, pagination) {

                self.placesSearchCB(data, status, pagination);

            });

        },

        // 검색 결과 콜백
        placesSearchCB: function (data, status, pagination) {

            let self = this;

            if (status === kakao.maps.services.Status.OK) {

                self.displayPlaces(data);
                self.displayPagination(pagination);

            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                alert('검색 결과가 존재하지 않습니다.');

                self.removeMarker();

                document.getElementById('placesList').innerHTML = '';
                document.getElementById('pagination').innerHTML = '';

            } else if (status === kakao.maps.services.Status.ERROR) {

                alert('검색 중 오류가 발생했습니다.');

            }

        },

        // 검색 결과 목록 및 마커 표시
        displayPlaces: function (places) {

            let self = this;

            let listEl = document.getElementById('placesList');

            let fragment = document.createDocumentFragment();

            let bounds = new kakao.maps.LatLngBounds();

            listEl.innerHTML = '';

            self.removeMarker();

            for (let i = 0; i < places.length; i++) {

                let placePosition = new kakao.maps.LatLng(
                    places[i].y,
                    places[i].x
                );

                let marker = self.addMarker(placePosition, i);

                let itemEl = self.getListItem(i, places[i]);

                bounds.extend(placePosition);

                // 마커 및 목록 이벤트
                (function(marker, title) {

                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        self.displayInfowindow(marker, title);
                    });

                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        self.infowindow.close();
                    });

                    itemEl.onmouseover = function() {
                        self.displayInfowindow(marker, title);
                    };

                    itemEl.onmouseout = function() {
                        self.infowindow.close();
                    };

                    itemEl.onclick = function() {
                        self.map.panTo(marker.getPosition());
                        self.displayInfowindow(marker, title);
                    };

                })(marker, places[i].place_name);

                fragment.appendChild(itemEl);

            }

            listEl.appendChild(fragment);

            self.map.setBounds(bounds);

        },

        // 검색 결과 아이템 생성
        getListItem: function (index, place) {

            let el = document.createElement('li');

            let itemStr =
                '<div class="info">' +
                '<h5>' + place.place_name + '</h5>';

            if (place.road_address_name) {

                itemStr +=
                    '<span>' + place.road_address_name + '</span>' +
                    '<span class="gray">' + place.address_name + '</span>';

            } else {

                itemStr += '<span>' + place.address_name + '</span>';

            }

            if (place.phone) {
                itemStr += '<span class="tel">' + place.phone + '</span>';
            }

            itemStr += '</div>';

            el.innerHTML = itemStr;
            el.className = 'item';

            return el;

        },

        // 마커 생성
        addMarker: function (position, idx) {

            let self = this;

            let marker = new kakao.maps.Marker({
                position: position
            });

            marker.setMap(self.map);

            self.markers.push(marker);

            return marker;

        },

        // 마커 제거
        removeMarker: function () {

            let self = this;

            for (let i = 0; i < self.markers.length; i++) {

                self.markers[i].setMap(null);

            }

            self.markers = [];

        },

        // 페이지 번호 표시
        displayPagination: function (pagination) {

            let self = this;

            let paginationEl = document.getElementById('pagination');

            paginationEl.innerHTML = '';

            for (let i = 1; i <= pagination.last; i++) {

                let el = document.createElement('a');

                el.href = '#';
                el.innerHTML = i;

                if (i === pagination.current) {

                    el.className = 'on';

                } else {

                    el.onclick = (function(page) {

                        return function(e) {

                            e.preventDefault();

                            pagination.gotoPage(page);

                        };

                    })(i);

                }

                paginationEl.appendChild(el);

            }

        },

        // 인포윈도우 표시
        displayInfowindow: function (marker, title) {

            let self = this;

            let content =
                '<div style="padding:5px;">' +
                title +
                '</div>';

            self.infowindow.setContent(content);

            self.infowindow.open(self.map, marker);

        }

    },

    mounted() {

        let self = this;

        // 페이지 시작 시 지도 생성
        self.fnList();

    }

});

app.mount('#app');
</script>

</body>
</html>