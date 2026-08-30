.DEFAULT_GOAL := help

.PHONY: help new

post_name := $(filter-out new,$(MAKECMDGOALS))

help:
	@printf '%s\n' 'Create a post with: make new your-post-slug'

new:
	@set -- $(post_name); \
	if [ "$$#" -ne 1 ]; then \
		printf '%s\n' 'Usage: make new your-post-slug' >&2; exit 2; \
	fi; \
	case "$$1" in \
		/*|*..*) printf '%s\n' 'Usage: make new your-post-slug' >&2; exit 2 ;; \
	esac; \
	hugo new content "posts/$$1.md" && \
	printf '%s\n' "Created: content/posts/$$1.md"

%:
	@:
