package com.kitri.util;

import java.io.*;
import java.net.*;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import com.kitri.dto.FilmDto;

public class CallAPI {
	
	/**
	 * ---------------------------------- 1 ----------------------------------
	 * <HTTP GET으로 API 호출하기> 메소드 - HttpUrlConnection 사용
	 * 
	 * [인자값]
	 * - String httpUrl : 파라미터 포함 url
	 * - Boolean header : 헤더		         *헤더 없으면 false 넣기
	 * 
	 * [return]
	 * - API 응답결과 (JSON형식의 String 타입)
	 */
	public static String APIHttpGet(String httpUrl, Boolean header) {

		String response = ""; // 응답 결과 담을 String

		try {

			// ① HttpUrlConnection 객체 생성 및 세팅
			URL obj = new URL(httpUrl);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();

			con.setRequestMethod("GET"); // 전송방식 설정 (GET)
			con.setConnectTimeout(30000); // 연결 제한시간 30초
			con.setReadTimeout(10000); // 컨텐츠 조회 제한시간 10초

			// 헤더가 있을 경우,
			if (header != null) {
				/*
				 * Iterator<String> keys = header.keySet().iterator(); while (keys.hasNext()) {
				 * String key = keys.next(); String value = (String) header.get(key);
				 * con.setRequestProperty(key, value); // Request 헤더 설정 }
				 */
				
				con.setRequestProperty("X-Naver-Client-Id", "Fc4lGVGl3zDMtizzcZbx");
				con.setRequestProperty("X-Naver-Client-Secret", "q3OgVCUh0y");
				
			}

			int responseCode = con.getResponseCode(); // response의 status 코드 얻어옴

			// ② 호출이 정상일 때, 응답 결과 사용
			if (responseCode == 200) {

				Charset charset = Charset.forName("UTF-8");
				BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), charset));
				String inputLine;
				StringBuffer sr = new StringBuffer();

				while ((inputLine = in.readLine()) != null) {
					sr.append(inputLine);
				}
				in.close();

				response = sr.toString(); // 응답결과 저장
			} else {
			
				System.out.println("예외코드 : " + responseCode);
				System.out.println("예외 결과 : " + con.getInputStream().toString());
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println("APIHttpGet 최종 결과 : " + response);
		return response;

	} // APIHttpGet() end



	/**
	 * ---------------------------------- 2 ---------------------------------- 
	 * <고화질 포스터 이미지 주소 + 네이버 코드 + 네이버 별점 얻기> 메소드
	 * 네이버 영화 검색 api + 크롤링
	 * 
	 * [인자값]
	 * - String movieNm	 : 영화 제목
	 * - String prdtYear : 제작년도    *제작년도 없으면 null로 주기!
	 *
	 * [return]
	 * - 고화질 포스터 이미지 주소, 네이버 코드, 네이버 별점 (FilmDto 타입)
	 */
	public static FilmDto getPoster(String movieNm, String prdtYear) {

		// HighImageUrl = 고화질 포스터 이미지 주소
		FilmDto HighImageUrl = new FilmDto();
		
		try {

			// 1. 네이버 영화 목록 검색 API
			// ① url + 파라미터 값 설정
			String url = "https://openapi.naver.com/v1/search/movie.json";				// API 호출 URL
			String search = URLEncoder.encode(movieNm, "UTF-8");				     	// 파라미터값 (UTF-8인코딩 필수)
			String paramNaver = "";
			
			if(prdtYear!=null) {
				paramNaver = "query=" + search + "&display=1&yearfrom=" + prdtYear + "&yearto=" + prdtYear;
			} else {
				paramNaver = "query=" + search + "&display=1";
			}
			String httpUrl = url + "?" + paramNaver;									   		// 최종 URL
			
			// ② 헤더값 생성
			HashMap<String, String> header = new HashMap<>();
			header.put("X-Naver-Client-Id", "Fc4lGVGl3zDMtizzcZbx");
			header.put("X-Naver-Client-Secret", "q3OgVCUh0y");
			
			// ③ API 호출 (GET)
			String responseNaver = APIHttpGet(httpUrl, true);  // HttpUrlConnection 사용
			
			// ④ responseNaver (JSON) 파싱
			JSONParser jsonParser = new JSONParser();
			
			System.out.println("responseNaver : " + responseNaver);
			JSONObject jsonObject = (JSONObject) jsonParser.parse(responseNaver);
	
			JSONArray imageArray = (JSONArray) jsonObject.get("items");
			
			// 2. 네이버 영화 포스터 url 크롤링
			int len2 = imageArray.size();
			for (int j = 0; j < len2; j++) {
				
				JSONObject imageArrayItems = (JSONObject) imageArray.get(j);
				
				// movieImageUrl = 검색결과의 이미지 주소
				String movieImageUrl = (String) imageArrayItems.get("link");

		        int beginIndex = movieImageUrl.lastIndexOf("=") + 1;
		        String movieCdNaver = movieImageUrl.substring(beginIndex); // movieCdNaver = 영화코드(네이버)
	
		        HighImageUrl.setMovieCdNaver(movieCdNaver);	 								// 영화코드(네이버) set
		        HighImageUrl.setStarPointNaver(imageArrayItems.get("userRating").toString());	// 네이버 별점 set
		        
		        // 네이버 영화의 고화질 포스터 주소를 크롤링
		        String connUrl = "https://movie.naver.com/movie/bi/mi/photoViewPopup.nhn?movieCode=" + movieCdNaver;
		        
				Document doc = Jsoup.connect(connUrl).get();
				Element imgtag = doc.getElementById("targetImage");
				
				if(imgtag != null) {
					HighImageUrl.setMovieImage(imgtag.attr("src").toString()); 			// 이미지 주소 set
				} else {
					// 네이버 제공 고화질 이미지 주소가 없는 경우, 기본 이미지로 나오게 함.
					HighImageUrl.setMovieImage("/MovieHolic/images/noMovieImage.png");
				}

	
			} // for문 end
			
			} catch (IOException e) {
				e.printStackTrace();
			} catch (ParseException e) {
				e.printStackTrace();
			
			} // try catch end
		
		return HighImageUrl;

	} // getPoster() end
	
	
	/**
	 * ---------------------------------- 3 ---------------------------------- 
	 * <1초 쉬기> 메소드
	 */
	public static void Sleep() {
		
		try {
				Thread.sleep(1000); //1초 대기

			}catch (InterruptedException e) {
				e.printStackTrace();
			}
	}
	
	
	////////////////////////////////////////사용 안 함(임시보류)//////////////////////////////////////////////
	/**
	 * ---------------------------------- 4 ---------------------------------- 
	 * <HTTP GET으로 API 호출하기> 메소드 - HttpClient 라이브러리 사용
	 * 
	 * [인자값]
	 * - String httpUrl : 파라미터 포함 url
	 * - HashMap header : 헤더(key-value)           *헤더 없으면 null 넣기
	 * 
	 * [return]
	 * - API 응답결과 (JSON형식의 String 타입)
	 */
	public static String APIHttpClientGet(String httpUrl, HashMap<String, String> header) {

		String response = ""; // 응답 결과 담을 String

		try {

			// ① HttpClient 객체 생성 및 세팅
			HttpClient client = HttpClientBuilder.create().build(); // HttpClient 생성
			HttpGet getRequest = new HttpGet(httpUrl); // GET 메소드 URL 생성

			// 헤더가 있을 경우,
			if (header != null) {
				Iterator<String> keys = header.keySet().iterator();
				while (keys.hasNext()) {
					String key = keys.next();
					String value = (String) header.get(key);
					getRequest.addHeader(key, value); // Request 헤더 설정
				}
			}

			HttpResponse httpResponse = client.execute(getRequest);

			// ② 호출이 정상일 때, 응답 결과 사용
			if (httpResponse.getStatusLine().getStatusCode() == 200) {

				ResponseHandler<String> handler = new BasicResponseHandler();
				response = handler.handleResponse(httpResponse); // 응답 결과 저장
			}

		} catch (Exception e) {
			System.err.println(e.toString());

		} // try catch end

		return response;

	} // APIHttpClientGet() end
	
	
} // class end