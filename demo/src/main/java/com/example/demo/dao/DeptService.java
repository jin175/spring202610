package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DeptMapper;
import com.example.demo.model.Dept;

@Service
public class DeptService {
	@Autowired
	DeptMapper deptMapper;
	
	public HashMap<String, Object> getDeptList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			List<Dept> list = deptMapper.selectDeptList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getDept(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			Dept info = deptMapper.selectDept(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addDept(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = deptMapper.insertDept(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> removeDept(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = deptMapper.deleteDept(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> editDept(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = deptMapper.updateDept(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
}
