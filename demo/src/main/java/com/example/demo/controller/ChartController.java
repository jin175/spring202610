package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.mapper.ProductMapper;

@Controller
public class ChartController {
	@RequestMapping("/chart1.do")
	public String test(Model model) throws Exception{
		
		return "/chart/chart1";
	}
	
	
	@RequestMapping("/chart2.do")
	public String chart2(Model model) throws Exception{
		
		return "/chart/chart2";
	}
	
	
	@RequestMapping("/chart3.do")
	public String chart3(Model model) throws Exception{
		
		return "/chart/chart3";
	}
	
	
	@Autowired
	ProductMapper productMapper;

	@ResponseBody
	@RequestMapping("/getProductSales")
	public List<HashMap<String, Object>> getProductSales() {
	    return productMapper.selectProductSales();
	}
}

