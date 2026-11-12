<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카카오맵 스마트 장소 검색</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!-- 카카오맵 API (libraries=services 필수) -->
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=70a38a244a850ec49100c42962a80b5b&libraries=services"></script>

    <style>
        body { font-family: 'Malgun Gothic', sans-serif; margin: 20px; }
        .container { display: flex; gap: 20px; flex-wrap: wrap; }
        .search-container { margin-bottom: 15px; display: flex; gap: 8px; align-items: center; }
        .category-buttons { margin-bottom: 10px; display: flex; gap: 6px; }
        .category-buttons button { padding: 6px 12px; cursor: pointer; border: 1px solid #ccc; background: #f9f9f9; border-radius: 4px; }
        .category-buttons button.active { background: #fee500; border-color: #e5cc00; font-weight: bold; }
        
        #map { width: 600px; height: 500px; border-radius: 8px; border: 1px solid #ddd; }
        .sidebar { width: 400px; height: 500px; display: flex; flex-direction: column; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; }
        
        #placesList { padding: 0; margin: 0; list-style: none; overflow-y: auto; flex-grow: 1; }
        .item { padding: 12px; border-bottom: 1px solid #eee; cursor: pointer; transition: background 0.2s; }
        .item:hover { background-color: #f1f3f5; }
        .item.selected { background-color: #e8f0fe; }
        
        .info h5 { margin: 0 0 5px; font-size: 15px; color: #333; }
        .info span { display: block; font-size: 13px; color: #555; margin-bottom: 2px; }
        .info .gray { color: #888; font-size: 11px; }
        .info .tel { color: #007bff; font-weight: 500; margin-top: 4px; }
        
        #pagination { padding: 10px; text-align: center; background: #fdfdfd; border-top: 1px solid #ddd; }
        #pagination a { display: inline-block; padding: 5px 10px; margin: 0 2px; cursor: pointer; text-decoration: none; color: #333; border: 1px solid #ddd; border-radius: 3px; }
        #pagination a.on { background: #007bff; color: #fff; font-weight: bold; border-color: #007bff; }

        /* 스프라이트 마커용 CSS */
        .map_wrap { position:relative; width:100%; height:500px; }
        .bg_white { background:#fff; }
    </style>
</head>

<body>

<div id="app">

    <h2>📍 카카오맵 스마트 장소 검색</h2>

    <!-- 카테고리 빠른 검색 버튼 -->
    <div class="category-buttons">
        <button type="button" @click="searchCategory('FD6')" :class="{active: currentCategory === 'FD6'}">음식점</button>
        <button type="button" @click="searchCategory('CE7')" :class="{active: currentCategory === 'CE7'}">카페</button>
        <button type="button" @click="searchCategory('CS2')" :class="{active: currentCategory === 'CS2'}">편의점</button>
        <button type="button" @click="searchCategory('HP8')" :class="{active: currentCategory === 'HP8'}">병원</button>
        <button type="button" @click="searchCategory('PM9')" :class="{active: currentCategory === 'PM9'}">약국</button>
    </div>

    <!-- 검색창 -->
    <div class="search-container">
        <input type="text"
               v-model="keyword"
               @keyup.enter="searchPlaces"
               placeholder="키워드 입력 (예: 강남역 맛집)"
               style="padding: 8px; width: 250px; border: 1px solid #ccc; border-radius: 4px;">
        <button type="button" @click="searchPlaces" style="padding: 8px 16px; background: #fee500; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">검색</button>
        <button type="button" @click="resetSearch" style="padding: 8px 12px; background: #f1f3f5; border: 1px solid #ccc; border-radius: 4px; cursor: pointer;">초기화</button>
    </div>

    <!-- 지도 및 목록 레이아웃 -->
    <div class="container">
        <!-- 지도 -->
        <div id="map"></div>

        <!-- 검색 결과 사이드바 -->
        <div class="sidebar">
            <ul id="placesList">
                <li v-if="places.length === 0" style="padding: 20px; text-align: center; color: #888;">
                    검색 결과가 없습니다. 키워드를 입력하거나 카테고리를 선택하세요.
                </li>
                <li v-for="(place, index) in places" 
                    :key="place.id" 
                    class="item"
                    @mouseover="displayInfowindow(markers[index], place.place_name)"
                    @mouseout="infowindow.close()"
                    @click="panToPlace(place, index)"
                    :class="{ selected: selectedIndex === index }">
                    <div class="info">
                        <h5>{{ index + 1 }}. {{ place.place_name }}</h5>
                        <span v-if="place.road_address_name">{{ place.road_address_name }}</span>
                        <span class="gray" v-if="place.address_name">[지번] {{ place.address_name }}</span>
                        <span class="tel" v-if="place.phone">📞 {{ place.phone }}</span>
                    </div>
                </li>
            </ul>

            <!-- 페이지 번호 -->
            <div id="pagination" v-show="paginationObj && paginationObj.last > 1">
                <a href="#" v-for="page in paginationObj.last" 
                   :key="page" 
                   :class="{ on: page === paginationObj.current }"
                   @click.prevent="gotoPage(page)">
                    {{ page }}
                </a>
            </div>
        </div>
    </div>

</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            keyword: '',
            map: null,
            ps: null,
            infowindow: null,
            markers: [],
            places: [],           // Vue 데이터 바인딩을 위한 장소 배열
            paginationObj: null,  // 페이지네이션 정보 객체
            selectedIndex: null,  // 선택된 리스트 인덱스
            currentCategory: ''   // 현재 선택된 카테고리 코드
        };
    },
    methods: {
        // 지도 초기화 (현재 위치 중심 탐색 적용)
        initMap() {
            let self = this;
            let mapContainer = document.getElementById('map');
            let defaultLat = 37.566826;
            let defaultLng = 126.9786567;

            let mapOption = {
                center: new kakao.maps.LatLng(defaultLat, defaultLng),
                level: 3
            };

            self.map = new kakao.maps.Map(mapContainer, mapOption);
            self.ps = new kakao.maps.services.Places();
            self.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

            // HTML5 Geolocation을 지원하는 경우 현재 위치로 지도 중심 이동
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    let lat = position.coords.latitude;
                    let lon = position.coords.longitude;
                    let locPosition = new kakao.maps.LatLng(lat, lon);
                    self.map.setCenter(locPosition);
                }, function(error) {
                    console.warn('위치 정보를 가져올 수 없어 기본 서울 위치로 설정합니다.', error);
                });
            }
        },

        // 키워드 검색
        searchPlaces() {
            let self = this;
            let keyword = self.keyword.trim();

            if (!keyword) {
                alert('검색어를 입력해주세요!');
                return;
            }

            self.currentCategory = ''; // 키워드 검색 시 카테고리 선택 해제
            self.ps.keywordSearch(keyword, function(data, status, pagination) {
                self.placesSearchCB(data, status, pagination);
            });
        },

        // 카테고리별 검색
        searchCategory(categoryCode) {
            let self = this;
            self.currentCategory = categoryCode;
            self.keyword = ''; // 카테고리 검색 시 키워드 초기화

            // 지도 중심 좌표 기준으로 카테고리 검색 수행
            let centerLatLng = self.map.getCenter();

            self.ps.categorySearch(categoryCode, function(data, status, pagination) {
                self.placesSearchCB(data, status, pagination);
            }, {
                location: centerLatLng,
                radius: 5000, // 반경 5km 이내
                useMapBounds: true
            });
        },

        // 검색 결과 콜백 처리
        placesSearchCB(data, status, pagination) {
            let self = this;

            if (status === kakao.maps.services.Status.OK) {
                self.places = data;
                self.paginationObj = pagination;
                self.displayPlaces(data);
            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                alert('검색 결과가 존재하지 않습니다.');
                self.resetResults();
            } else if (status === kakao.maps.services.Status.ERROR) {
                alert('검색 중 오류가 발생했습니다.');
            }
        },

        // 마커 및 지도 영역 재설정
        displayPlaces(places) {
            let self = this;
            let bounds = new kakao.maps.LatLngBounds();

            self.removeMarker();

            for (let i = 0; i < places.length; i++) {
                let placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
                let marker = self.addMarker(placePosition, i);

                bounds.extend(placePosition);

                // 마커 이벤트 연결
                kakao.maps.event.addListener(marker, 'mouseover', (function(m, title) {
                    return function() {
                        self.displayInfowindow(m, title);
                    };
                })(marker, places[i].place_name));

                kakao.maps.event.addListener(marker, 'mouseout', function() {
                    self.infowindow.close();
                });
            }

            self.map.setBounds(bounds);
        },

        // 마커 생성
        addMarker(position, idx) {
            let self = this;
            let imageSrc = 'https://t1.daumcdn.net/localimg/jsimages/marker_number_sprite.png'; // 마커 스프라이트 이미지
            let imageSize = new kakao.maps.Size(36, 37);
            let imgOptions = {
                spriteSize: new kakao.maps.Size(36, 691),
                spriteOrigin: new kakao.maps.Point(0, (idx * 46) + 10),
                offset: new kakao.maps.Point(13, 37)
            };
            let markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions);
            let marker = new kakao.maps.Marker({
                position: position,
                image: markerImage
            });

            marker.setMap(self.map);
            self.markers.push(marker);
            return marker;
        },

        // 마커 초기화
        removeMarker() {
            let self = this;
            for (let i = 0; i < self.markers.length; i++) {
                self.markers[i].setMap(null);
            }
            self.markers = [];
        },

        // 결과 초기화
        resetSearch() {
            let self = this;
            self.keyword = '';
            self.places = [];
            self.paginationObj = null;
            self.currentCategory = '';
            self.removeMarker();
            self.infowindow.close();
        },

        // 페이지 이동
        gotoPage(page) {
            let self = this;
            self.paginationObj.gotoPage(page);
        },

        // 리스트 클릭 시 해당 위치로 이동 및 하이라이트
        panToPlace(place, index) {
            let self = this;
            self.selectedIndex = index;
            let moveLatLon = new kakao.maps.LatLng(place.y, place.x);
            self.map.panTo(moveLatLon);
            self.displayInfowindow(self.markers[index], place.place_name);
        },

        // 인포윈도우 표시
        displayInfowindow(marker, title) {
            let self = this;
            let content = `<div style="padding:5px;font-size:12px;font-weight:bold;">${title}</div>`;
            self.infowindow.setContent(content);
            self.infowindow.open(self.map, marker);
        }
    },
    mounted() {
        this.initMap();
    }
});

app.mount('#app');
</script>

</body>
</html>