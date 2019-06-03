<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/template/header.jsp"%>
<%@ include file="/template/nav_style.jsp"%>
<%@ include file="/template/boot_431.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>

<c:set var="ap" value="${requestScope.ap}" />
<c:set var="np" value="${requestScope.np}" />





<script>
// 회원관리 게시판 처리
$(function() {
	$("div>span>span>a").click(
		function() {
			$("div.wrapper>div.container>div.member_search_result").empty();
			var url = $(this).attr("href");
			$.ajax({
			
				url : url,
				method : 'get',
				success : function(result) {
				$("div.wrapper>div.container>div.member_search_result").html(result.trim());
				}
			});
		return false;
	});
});

	
	
$(function() {
	$(".page>a").click(function() {
	var currentPage = $(this).attr("href");
	$.ajax({
		url : '/MovieHolic/admin?act=alllis&' + currentPage,
			method : 'get',
			/* data : 'alllist=' + alllist,  */
			success : function(result) {
				$("section").html(result.trim());
			}
		});
	return false;
	});
});





//신고 관리 게시글
/* $(function() {
	/* $("div.wrapper>div.container>div.member_search_result").empty(); */
		$.ajax({
			url : '/MovieHolic/admin?npact=notify',
			method : 'get',
			success : function(result) {
				/* $(".notify_search_result").html(result.trim()); //section#section */
			}
		});
	return false;
});   */



</script>



<style>
tr>td>input {
	-ms-transform: scale(2); /* IE */
	-moz-transform: scale(2); /* FF */
	-webkit-transform: scale(2); /* Safari and Chrome */
	-o-transform: scale(2); /* Opera */
}

.container {
	/* background-image: url("/Content/img/datepicker/s4.png"); /* ???*/
	background-position: center;
	background-repeat: no-repeat;
	height: 740px;
	text-align: center;
}

.top {
	padding-top: 290px;
}

#field {
	width: 200px;
	line-height: 37px;
	text-align: center;
	background-color: white;
	opacity: 0.83;
	padding: 7px;
	margin: 0 auto;
}

/* 구분선 굵은 것 */
hr.line_bold {
	background-color: white;
	height: 2px;
	position: static;
}

/* 구분선 얇은 것 (흰색) */
hr.line_light_w {
	background-color: white;
	position: static;
}
</style>



</head>

<body class="left-sidebar is-preload">


	<div id="page-wrapper">


		<!-- Header -->
		<div id="header" style="background-image: none;">
			<%@ include file="/template/nav.jsp"%>
		</div>





		<!-- Main -->

		<div class="wrapper style1">

			<div class="container">

				<!-- 회원 관리 -->
				<div class="row" style="margin-bottom: -5em;">

					<div class="col-lg-6">
						<h2 align="left">회원 관리</h2>
					</div>

					<div class="col-lg-1">
						<div class="dropdown">
							<button type="button" class="btn btn-success dropdown-toggle"
								data-toggle="dropdown">이름</button>
							<div class="dropdown-menu">
								<a class="dropdown-item" href="#">아이디</a>
							</div>
						</div>
					</div>

					<div class="col-lg-5">
						<div class="input-group mb-3" align="right">
							<input type="text" class="form-control" placeholder="검색"
								id="name" name="name">
							<div class="input-group-append">
								<button type="submit" class="btn btn-success" style="z-index: 0">검색</button>
							</div>
						</div>
					</div>

					<hr style="color: #fff">
				</div>


				<hr class="line_light_w">

				<div align="right">
					<span class="dropdown">
						<button type="button" class="btn btn-success dropdown-toggle"
							data-toggle="dropdown">목록</button> <span class="dropdown-menu">
							<a class="dropdown-item" href="/MovieHolic/admin?act=alllist">전체목록</a>
							<%-- DB number값이 1일때 휴면. --%> <a class="dropdown-item"
							href="/MovieHolic/admin?act=inactiveList">휴면목록</a> <a
							class="dropdown-item"
							href="/MovieHolic/admin?act=unsubscribelist">탈퇴목록</a>
					</span>
					</span>
					<button type="submit" class="btn btn-success" style="z-index: 0">탈퇴</button>
					<button type="submit" class="btn btn-success" style="z-index: 0">휴면</button>
				</div>




				<!-- <section id="section"> -->
				<div class="member_search_result">


					<table class="table" style="border-bottom: 0.2em solid #fff;">
						<br>
						<thead>
							<tr>
								<th>
									<div id="check-all">
										<button type="button" class="btn btn-success"
											style="z-index: 0;">전체선택</button>
									</div>
								</th>
								<th>회원ID</th>
								<th>이름</th>
								<th>주민번호 앞자리</th>
								<th>연락처</th>
								<th>성별</th>
								<th>가입일</th>
								<th>탈퇴일</th>
								<th>휴면여부</th>
							</tr>
						</thead>
						<tbody>

							<c:forEach var="ap" items='${ap.list}'>
								<tr>
									<td><input type="checkbox" class="ab" name="chk" /></td>
									<td>${ap.userId}</td>
									<td>${ap.name }</td>
									<td>${ap.birth }</td>
									<td>${ap.phoneFirst }-${ap.phoneMid }-${ap.phoneLast }</td>
									<td>${ap.gender }</td>
									<td>${ap.joinDate }</td>
									<td>${ap.outdate }</td>
									<td>


										<div>
											<span class="enable">
												<button type="button"
													class="btn btn-success dropdown-toggle"
													data-toggle="dropdown">

													<c:if test="${ap.enable == 1}">휴면</c:if>
													<c:if test="${ap.enable == 0}">활동</c:if>

												</button>
											</span>

											<div class="dropdown-menu">
												<a class="dropdown-item" href="#"> <c:if
														test="${ap.enable == 1}">활동</c:if> <c:if
														test="${ap.enable == 0}">휴면</c:if>
												</a>
											</div>
										</div>

									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>



					<div class="row">

						<div class="col-lg-2">


							<c:if test="${ap.startPage > 1 }">
								<span class="page"> <a href="${ap.startPage - 1}"><button
											class="btn btn-success">이전</button></a>
								</span>

							</c:if>


						</div>


						<div class="col-lg-2"></div>

						<div class="col-lg-4">
							<ul class="pagination"
								style="width: 240px; margin-left: auto; margin-right: auto;">

								<c:forEach begin="${ap.startPage}" end="${ap.endPage}" var="i">
									<c:choose>

										<c:when test="${ap.currentPage == i}">
											<li class="page-item"><span><a class="page-link">${i}</a></span></li>
										</c:when>

										<c:otherwise>
											<li class="page-item"><span class="page"><a
													class="page-link" href="${i}">${i}</a></span></li>
										</c:otherwise>

									</c:choose>
								</c:forEach>

							</ul>
						</div>



						<div class="col-lg-2"></div>





						<div class="col-lg-2">

							<c:if test="${ap.totalPage > ap.endPage }">

								<span class="page"> <a href="${ap.endPage+1}"><button
											class="btn btn-success">다음</button></a>
								</span>

							</c:if>

						</div>


					</div>


					<!-- </section> -->
				</div>
				<!-- member_search_result -->

			</div>
			<br> <br> <br>




			<%-- -------------------------------------------------------------------------------------------------- --%>



			<!-- 신고 게시글 관리 -->
			<div class="container">


				<div class="row" style="margin-bottom: -5em;">
					<div class="col-lg-4">
						<h2 align="left">신고 게시글 관리</h2>
					</div>
					<div class="col-lg-4"></div>
					<div class="col-lg-4"></div>

					<hr style="color: #fff">
				</div>


				<hr class="line_light_w">

				<div align="right">
					<button type="submit" class="btn btn-success" style="z-index: 0">삭제</button>
				</div>











				<div class="notifiy_search_result">


				<table class="table" style="border-bottom: 0.2em solid #fff;">
						<br>
						<thead>
							<tr>
								<th></th>
								<th>번호</th>
								<th>분류</th>
								<th>작성자ID</th>
								<th>제목</th>
								<th>내용</th>
								<th>작성일</th>
								<th>신고수</th>
							</tr>
						</thead>
						<tbody>
						
						
							<c:forEach var="np" items='${np.list}'>
								<tr>
									<td><input type="checkbox" /></td>
									<td>${np.row }</td>
									<td>${np.boardName }</td>
									<td>${np.userId }</td>
									<td>${np.subject }</td>
									<td>${np.content }</td>
									<td>${np.postDate }</td>
									<td>${np.notify }</td>
								</tr>
							</c:forEach>	
							
							
							
							
						</tbody>
					</table>


					<div class="row">


						<div class="col-lg-2">
							<button type="submit" class="btn btn-success">이전</button>
						</div>

						<div class="col-lg-2"></div>

						<div class="col-lg-4">
							<ul class="pagination"
								style="width: 240px; margin-left: auto; margin-right: auto;">
								<li class="page-item"><a class="page-link" href="#">1</a></li>
								<li class="page-item"><a class="page-link" href="#">2</a></li>
								<li class="page-item"><a class="page-link" href="#">3</a></li>
								<li class="page-item"><a class="page-link" href="#">4</a></li>
								<li class="page-item"><a class="page-link" href="#">5</a></li>
							</ul>
						</div>

						<div class="col-lg-2"></div>

						<div class="col-lg-2">
							<button type="submit" class="btn btn-success">다음</button>
						</div>
					</div>



				</div>	
					
					
					
					
				<!-- notify_search_result -->


			</div>


		</div>







		<%@ include file="/template/footer.jsp"%>