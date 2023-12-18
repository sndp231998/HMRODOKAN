package com.hmro.dokan.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hmro.dokan.entities.Sales;

public interface SalesRepo extends  JpaRepository<Sales, Integer> {

}
