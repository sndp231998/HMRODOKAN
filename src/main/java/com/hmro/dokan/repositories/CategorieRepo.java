package com.hmro.dokan.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hmro.dokan.entities.Categories;

public interface CategorieRepo extends  JpaRepository<Categories, Integer> {

}
