package com.hmro.dokan.services.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hmro.dokan.entities.Categories;
import com.hmro.dokan.exception.ResourceNotFoundException;
import com.hmro.dokan.playloads.CategoryDto;
import com.hmro.dokan.repositories.CategorieRepo;
import com.hmro.dokan.services.CategoryService;


@Service
public class CategoryServiceImpl implements CategoryService{

	@Autowired
	private CategorieRepo categoryRepo;
	
	@Autowired
	private ModelMapper modelMapper;
	
	@Override
	public CategoryDto createCategory(CategoryDto categoryDto) {
		Categories cat = this.modelMapper.map(categoryDto, Categories.class);
		Categories addedCat = this.categoryRepo.save(cat);
		return this.modelMapper.map(addedCat, CategoryDto.class);
	}

	@Override
	public CategoryDto updateCategory(CategoryDto categoryDto, Integer categoryId) {
		Categories cat = this.categoryRepo.findById(categoryId)
				.orElseThrow(() -> new ResourceNotFoundException("Category ", "Category Id", categoryId));

		cat.setCategoryTitle(categoryDto.getCategoryTitle());
		cat.setCategoryDescription(categoryDto.getCategoryDescription());

		Categories updatedcat = this.categoryRepo.save(cat);

		return this.modelMapper.map(updatedcat, CategoryDto.class);
	}
	
	


	@Override
	public void deleteCategory(Integer categoryId) {
		Categories cat = this.categoryRepo.findById(categoryId)
				.orElseThrow(() -> new ResourceNotFoundException("Category ", "category id", categoryId));
		this.categoryRepo.delete(cat);
	}


	@Override
	public CategoryDto getCategory(Integer categoryId) {
		Categories cat = this.categoryRepo.findById(categoryId)
				.orElseThrow(() -> new ResourceNotFoundException("Category", "category id", categoryId));

		return this.modelMapper.map(cat, CategoryDto.class);
	}
	
	
	@Override
	public List<CategoryDto> getCategories() {

		List<Categories> categories = this.categoryRepo.findAll();
		List<CategoryDto> catDtos = categories.stream().map((cat) -> this.modelMapper.map(cat, CategoryDto.class))
				.collect(Collectors.toList());

		return catDtos;
	}


}
