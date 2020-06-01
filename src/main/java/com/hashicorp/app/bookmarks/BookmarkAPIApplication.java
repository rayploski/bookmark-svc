package com.hashicorp.app.bookmarks;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;

import javax.ws.rs.core.Application;

@OpenAPIDefinition(
        info = @Info(
                title="Bookmark Service API",
                version = "0.1",
                contact = @Contact(
                  name =   "Bookmark Service Project",
                  url = "https://github.com/rayploski/bookmark-svc/issues"
                ),
                license = @License(
                        name = "Mozilla Public License, version 2.0",
                        url = "https://www.mozilla.org/en-US/MPL/2.0/"
                )
        )
)
public class BookmarkAPIApplication extends Application {
}
