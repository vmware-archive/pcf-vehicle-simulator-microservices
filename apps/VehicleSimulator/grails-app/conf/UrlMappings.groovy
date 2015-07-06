class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "map", action:"/index")
		"/map"(controller: "map")
        "500"(view:'/error')
	}
}
