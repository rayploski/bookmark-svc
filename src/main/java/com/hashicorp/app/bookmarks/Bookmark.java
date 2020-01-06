package com.hashicorp.app.bookmarks;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import java.util.List;

/**
 * Simple model of a bookmark
 * @author Ray Ploski
 */

@Entity
public class Bookmark extends PanacheEntity {

    @Column(length = 128)
    public String name;

    @Column(name = "bk_desc", length = 1024)
    public String description;

    @Column(length = 128)
    public String category;

    @Column(length = 2048, unique = true)
    public String url;


    public Bookmark() {

    }

    public static List<Bookmark> findByName(String name){
        return find("name", name).list();
    }

    public static List<Bookmark> findByUrl(String url){
        return find("url", url).list();
    }

}