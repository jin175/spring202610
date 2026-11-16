package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Member;

@Mapper
public interface MemberMapper {
	List<Member> selectMemberList(HashMap<String, Object> map);
	
	Member selectMember(HashMap<String, Object> map);
	
	int insertMember(HashMap<String, Object> map);
	
	int deleteMember(HashMap<String, Object> map);
	int updateMember(HashMap<String, Object> map);
}
