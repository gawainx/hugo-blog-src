.DEFAULT_GOAL := help

.PHONY: help post

help:
	@printf '%s\n' 'Create a post with: make post name=your-post-slug'

post:
	@post_name="$(name)"; \
	case "$$post_name" in \
		""|/*|*..*) printf '%s\n' 'Usage: make post name=your-post-slug' >&2; exit 2 ;; \
	esac; \
	printf '%s\n' "Creating content/posts/$$post_name.md"; \
	hugo new "posts/$$post_name.md"
