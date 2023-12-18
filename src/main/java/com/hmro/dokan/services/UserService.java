package com.hmro.dokan.services;

import java.util.List;

import com.hmro.dokan.playloads.UserDto;

public interface UserService {

	UserDto create1User(UserDto user);
	
	UserDto updateUser(UserDto user, Integer userId);
	
	UserDto getUserById(Integer userId);
	
	List<UserDto>getAllUsers();
	
	void deleteUser(Integer userId);
	
}
