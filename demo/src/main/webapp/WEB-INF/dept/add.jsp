<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <div>
            학과 번호 : <input v-model="deptNo">
         </div>
         <div>
            학과명 : <input v-model="dName">
         </div>
         <div>
            파트 : <input v-model="part">
         </div>
         <div>
            빌딩 : <input v-model="build">
         </div>
         <button @click="fnAdd">저장</button>
        
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                deptNo : "",
                dName : "",
                part : "",
                build : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd : function () {
                let self = this;
                let param = {
                    deptNo : self.deptNo,
                    dName : self.dName,
                    part : self.part,
                    build : self.build
                };
                $.ajax({
                    url: "/dept/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>