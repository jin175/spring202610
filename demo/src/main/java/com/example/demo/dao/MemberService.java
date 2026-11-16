package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.MemberMapper;
import com.example.demo.model.Member;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	
	public HashMap<String, Object> getMemberList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			List<Member> list = memberMapper.selectMemberList(map);
			
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	public HashMap<String, Object> getMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			Member info = memberMapper.selectMember(map);
			
			resultMap.put("info", info);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	
	public HashMap<String, Object> addMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = memberMapper.insertMember(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> removeMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = memberMapper.deleteMember(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> editMember(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			int result = memberMapper.updateMember(map);
			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	
	
}
