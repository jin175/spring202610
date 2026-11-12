package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.AreaMapper;
import com.example.demo.model.Area;

@Service
public class AreaService {
	
	
	@Autowired
	AreaMapper areaMapper;
	
	public HashMap<String, Object> getSiList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			// object -> 문자열 -> 숫자
			
			
			List<Area> siList = areaMapper.selectSiList(map);
			resultMap.put("siList", siList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getGuList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			// object -> 문자열 -> 숫자
			
			
			List<Area> guList = areaMapper.selectGuList(map);
			resultMap.put("guList", guList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getDongList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			// object -> 문자열 -> 숫자
			
			
			List<Area> dongList = areaMapper.selectDongList(map);
			resultMap.put("dongList", dongList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
}	
