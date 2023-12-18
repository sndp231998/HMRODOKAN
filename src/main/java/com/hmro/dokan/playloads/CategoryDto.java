package com.hmro.dokan.playloads;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Entity
@Data
public class CategoryDto {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer categoryId;
	
	
	@Column(name="title",length = 100,nullable = false)
	private String categoryTitle;
	
	
	//private String image;
	
	//private Integer store_id;
	//private Integer counter_id;
	
	
	@Column(name="description")
	//@Size(min=5, message="min size of category desc is 5")
	private String categoryDescription;
	
	
	
}
