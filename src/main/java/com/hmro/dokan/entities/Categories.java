package com.hmro.dokan.entities;

import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
//import javax.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Table(name="categories")
@NoArgsConstructor

@Data
public class Categories {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer categoryId;
	
	
	@Column(name="title",length = 100,nullable = false)
	private String categoryTitle;
	
	
	private String image;
	//private Integer store_id;
	//private Integer counter_id;
	
	
	@Column(name="description")
	//@Size(min=5, message="min size of category desc is 5")
	private String categoryDescription;
	
	
	@OneToMany(mappedBy="category",cascade=CascadeType.ALL,fetch=FetchType.LAZY)
	private List<Products>products=new ArrayList<>();
	
}
