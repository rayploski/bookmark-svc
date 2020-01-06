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
@Path("/bookmarks")
@Produces("application/json")
@Consumes("application/json")
public class BookmarkEndpoint {

    @GET
    public List<Bookmark> all() {
        return Bookmark.findAll().list();
    }

    @GET
    @Path("/by-name")
    public List<Bookmark> findByName(@PathParam String name){
        return Bookmark.findByName(name);
    }
    @GET
    @Path("/by-url")
    public List<Bookmark> findByUrl(@PathParam String url){
        return Bookmark.findByUrl(url);
    }

    @GET
    @Path("{id}")
    public Bookmark findById(@PathParam Long id) {
        Bookmark p = Bookmark.findById(id);
        if(p == null)
            throw new WebApplicationException(Response.Status.NOT_FOUND);
        return p;
    }

    @PUT
    @Path("{id}")
    @Transactional
    public Bookmark update(@PathParam Long id, Bookmark bookmark) 
    {

        if (bookmark.url == null ) {
            throw new WebApplicationException("Bookmark URL was not set on request.", 422);
       }

       Bookmark entity = Bookmark.findById(id);
       if (entity == null) {
        throw new WebApplicationException("Bookmark with id of " + id + " does not exist.", 404);
       }

    entity.name = bookmark.name;
    entity.url = bookmark.url;
    entity.description = bookmark.description;
    entity.category = bookmark.category;

    return entity;

    }

    @DELETE
    @Path("{id}")
    @Transactional
    public Response delete(@PathParam Long id) 
    {
        
        Bookmark entity = Bookmark.findById(id);
        
        if (entity == null) 
        {
            throw new WebApplicationException("Bookmark with id of " + id + " does not exist.", 404);
        }

        entity.delete();
        return Response.status(204).build();
    }

    @POST
    @Transactional
    public Response newBookmark(Bookmark newBookmark){
        Bookmark b = new Bookmark();
        b.name = newBookmark.name;
        b.category = newBookmark.category;
        b.description = newBookmark.description;
        b.url = newBookmark.url;
        Bookmark.persist(b);

        return Response.ok(b).status(201).build();
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
