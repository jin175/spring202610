package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.MemberService;
import com.google.gson.Gson;

@Controller
public class MemberController {
	@Autowired
	MemberService memberService;
	
	
	@RequestMapping("/member/list.do")
	public String test(Model model) throws Exception{
		return "/member/list";
	}
	
	@RequestMapping("/member/add.do")
	public String add(Model model) throws Exception{
		return "/member/add";
	}
	
	@RequestMapping("/member/view.do")
	public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		model.addAttribute("memberId", map.get("memberId"));
		return "/member/view";
	}

	@RequestMapping("/member/edit.do")
	public String edit(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		model.addAttribute("memberId", map.get("memberId"));
		return "/member/edit";
	}
	
	
	@RequestMapping(value = "/member/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.getMemberList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/member/view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String view2(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.getMember(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/member/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.addMember(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/member/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.removeMember(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/member/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String edit_(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = memberService.editMember(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	
}
