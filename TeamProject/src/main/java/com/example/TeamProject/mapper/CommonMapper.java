package com.example.TeamProject.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.TeamProject.model.Order;

@Mapper
public interface CommonMapper {
	
	List<Order> selectOrdersByBuyerId(HashMap<String, Object> map);
	
	
}
