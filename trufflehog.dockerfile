FROM trufflesecurity/trufflehog:latest

# Remove the original entrypoint so Jenkins can run shell commands
ENTRYPOINT []
CMD ["sh"]
