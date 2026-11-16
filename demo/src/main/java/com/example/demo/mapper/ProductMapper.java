package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Product;

@Mapper
public interface ProductMapper {
	// 제품 목록
	List<Product> selectProductList(HashMap<String, Object> map);
	
	// 제품 상세정보 (PK로 묶었을 때 - 하나뿐이라 (리스트가 아닌) 단일 객체로 받은것)
	Product selectProduct(HashMap<String, Object> map);
	
	// 카테고리 목록
	List<Product> selectCategoryList(HashMap<String, Object> map);
	
	// 결제 내용 추가
	int insertProductOrder(HashMap<String, Object> map);
	
	
}