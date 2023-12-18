package com.hmro.dokan.services;

import java.util.List;

import com.hmro.dokan.playloads.ProductDto;

public interface ProductSerevice {

	//create 

	ProductDto createProduct(ProductDto ProductDto,Integer userId,Integer categoryId);

	//update 

	ProductDto updateProduct(ProductDto ProductDto, Integer postId);

	// delete

	void deleteProduct(Integer pId);
	
	//get all posts
	
	//ProductResponse getAllProduct(Integer pageNumber,Integer pageSize,String sortBy,String sortDir);
	
	//get single post
	
	ProductDto getProductById(Integer postId);
	
	//get all posts by category
	
	List<ProductDto> getProductByCategory(Integer categoryId);
	
	//get all posts by user
	List<ProductDto> getProductByUser(Integer userId);
	
	//search posts
	List<ProductDto> searchProducts(String keyword);
	
	List<ProductDto>searchproduct(String scancode);

}

