package com.hashicorp.app.bookmarks;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Entity
public class Category extends PanacheEntity {

    @Column(length = 128)
    public String name;

    @OneToMany
    @JoinColumn(name ="fk_category")
    public Set<Bookmark> bookmarkSet;

    public Category() {

    }

    public static List<Category> findByName(String name){
        return find("name", name).list();
    }


}
