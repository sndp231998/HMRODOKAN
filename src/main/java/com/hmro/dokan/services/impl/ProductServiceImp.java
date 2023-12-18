package com.hmro.dokan.services.impl;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hmro.dokan.entities.Categories;
import com.hmro.dokan.entities.Products;
import com.hmro.dokan.entities.Users;
import com.hmro.dokan.exception.ResourceNotFoundException;
import com.hmro.dokan.playloads.ProductDto;
import com.hmro.dokan.repositories.CategorieRepo;
import com.hmro.dokan.repositories.ProductRepo;
import com.hmro.dokan.repositories.UserRepo;
import com.hmro.dokan.services.ProductSerevice;

@Service
public class ProductServiceImp implements ProductSerevice {

	@Autowired
    private ProductRepo productRepo;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private CategorieRepo categoryRepo;


    @Override
    public ProductDto createProduct(ProductDto productDto, Integer userId, Integer categoryId) {
        Users user = this.userRepo.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "User id", userId));

        Categories category = this.categoryRepo.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category", "category id", categoryId));

        Products product = this.modelMapper.map(productDto, Products.class);
        product.setImageName("default.png");
        product.setAddedDate(new Date());
        product.setUser(user);
        product.setCategory(category);
        product.setPp(productDto.getPp());
        product.setScancode(productDto.getScancode());
        product.setSp(productDto.getSp());
        product.setTitle(productDto.getTitle());

        Products newProduct = this.productRepo.save(product);

        return this.modelMapper.map(newProduct, ProductDto.class);
    }


	
	
	  @Override
		public ProductDto updateProduct(ProductDto ProductDto, Integer productId) {
		    Products product = this.productRepo.findById(productId)
	                .orElseThrow(() -> new ResourceNotFoundException("Product ", "product id", productId));

	        Categories category = this.categoryRepo.findById(ProductDto.getCategory().getCategoryId()).get();

	        product.setTitle(ProductDto.getTitle());
	       product.setSp(ProductDto.getSp());
	       product.setPp(ProductDto.getPp());
	       product.setAddedDate(new Date());
	       product.setQty(ProductDto.getQuantity());
	      // product.setScancode(null);
	        product.setImageName(ProductDto.getImageName());
	        product.setCategory(category);


	        Products updatedproduct = this.productRepo.save(product);
	        return this.modelMapper.map(updatedproduct, ProductDto.class);
	    }

	
	@Override
	public void deleteProduct(Integer productId) {
		// TODO Auto-generated method stub
		Products product=this.productRepo.findById(productId)
				.orElseThrow(()->new ResourceNotFoundException("Product","product id", productId));
	this.productRepo.delete(product);
	}

	
	
	
	@Override
	public ProductDto getProductById(Integer productId) {
	Products product=this.productRepo.findById(productId)
			.orElseThrow(()-> new ResourceNotFoundException("Product","product id", productId));
	return this.modelMapper.map(product, ProductDto.class);
	}

	
	@Override
	public List<ProductDto> getProductByCategory(Integer categoryId) {
		  Categories cat = this.categoryRepo.findById(categoryId)
	                .orElseThrow(() -> new ResourceNotFoundException("Category", "category id", categoryId));
	        List<Products> products = this.productRepo.findByCategory(cat);

	        List<ProductDto> productDtos = products.stream().map((product) -> this.modelMapper.map(products, ProductDto.class))
	                .collect(Collectors.toList());

	        return productDtos;
	}

	
	
	@Override
	public List<ProductDto> getProductByUser(Integer userId) {
		 Users user = this.userRepo.findById(userId)
	                .orElseThrow(() -> new ResourceNotFoundException("User ", "userId ", userId));
	        List<Products> products = this.productRepo.findByUser(user);

	        List<ProductDto> productDtos = products.stream().map((product) -> this.modelMapper.map(products, ProductDto.class))
	                .collect(Collectors.toList());

	        return productDtos;
		
	}

	@Override
	public List<ProductDto> searchProducts(String keyword) {
	    List<Products> products = this.productRepo.searchByTitle("%" + keyword + "%");
        List<ProductDto> productDtos = products.stream().map((product) -> this.modelMapper.map(product, ProductDto.class)).collect(Collectors.toList());
        return productDtos;
    }




	@Override
	public List<ProductDto> searchproduct(String scancode) {
	    List<Products> products = this.productRepo.findByScancode(scancode);

	    List<ProductDto> productDtos = products.stream()
	            .map(product -> this.modelMapper.map(product, ProductDto.class))
	            .collect(Collectors.toList());

	    return productDtos;
	}


}
