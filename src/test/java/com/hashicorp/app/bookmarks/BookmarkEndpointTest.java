package com.hashicorp.app.bookmarks;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
public class BookmarkEndpointTest {

    @Test
    public void testBookmarkEndpoint() {
        given()
          .when().get("/bookmarks")
          .then()
             .statusCode(200);
    }


    
}