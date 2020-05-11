package com.hashicorp.app.bookmarks;

import org.jboss.resteasy.annotations.jaxrs.PathParam;

import javax.enterprise.context.ApplicationScoped;
import javax.json.Json;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;
import java.util.List;

@ApplicationScoped
@Path("/categories")
@Produces("application/json")
@Consumes("application/json")
public class CategoryEndpoint {


    @GET
    public List<Category> all() {

        return Category.findAll().list();
    }

    @GET
    @Path("/by-name")
    public List<Category> findByName(@PathParam String name){

        return Category.findByName(name);
    }


    @GET
    @Path("/by-id")
    public Category findById(@PathParam Long id){
        Category c = Category.findById(id);
        if (c == null ){
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        }
        return c;
    }


    @PUT
    @Path("{id}")
    @Transactional
    public Category update (@PathParam Long id, Category cat){
        if (cat == null || cat.name.isEmpty()){
            throw new WebApplicationException("Category name may not be null or empty");
        }

        Category entity = Category.findById(id);
        if (entity == null ){
            throw new WebApplicationException("No Category found with id of " + id);
        }

        entity.name = cat.name;
        return  entity;
    }

    @DELETE
    @Path("{id}")
    @Transactional
    public Response delete(@PathParam Long id) {
        Category cat = Category.findById(id);

        if (cat == null) {
            throw new WebApplicationException(("No Category found with id of " + id));
        }

        cat.delete();
        return Response.status(204).build();
    }

    @POST
    @Transactional
    public Response newCategory(Category newCategory){

        Category cat = new Category();
        cat.name = newCategory.name;
        cat.persist();
        return Response.ok(cat).status(201).build();
    }


    @Provider
    public static class ErrorMapper implements ExceptionMapper<Exception> {

        @Override
        public Response toResponse(Exception exception) {
            int code = 500;
            if (exception instanceof WebApplicationException) {
                code = ((WebApplicationException) exception).getResponse().getStatus();
            }
            return Response.status(code)
                    .entity(Json.createObjectBuilder().add("error", exception.getMessage()).add("code", code).build())
                    .build();
        }

    }


}
