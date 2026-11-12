<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts@8.8.1/dist/apexcharts.min.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div id="chart"></div>


        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnChart: function () {
                    let self = this;

                    var options = {
                        chart: {
                            type: 'donut'
                        },
                        series: [44, 55, 13, 33],
                        labels: ['Apple', 'Mango', 'Orange', 'Watermelon']
                    };

                    // 차트를 생성하고 #chart 엘리먼트에 렌더링하는 코드 추가
                    var chart = new ApexCharts(document.querySelector("#chart"), options);
                    chart.render();
                }
            },
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnChart();
            }
        });

        app.mount('#app');
    </script>