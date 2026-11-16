package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Dept;


@Mapper
public interface DeptMapper {
	List<Dept> selectDeptList(HashMap<String, Object> map);
	
	Dept selectDept(HashMap<String, Object> map);
	
	int insertDept(HashMap<String, Object> map);
	
	int deleteDept(HashMap<String, Object> map);
	int updateDept(HashMap<String, Object> map);
}	
