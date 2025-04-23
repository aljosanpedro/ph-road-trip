# Walang Pangalang Road Trip

## Making a release version
- Commit everything first before making a tag.
- First, make a tag via the command:
  - `git tag v[X]` where `[X] is a version name`
  - `ie. git tag v1.0`
- Then, push the tag via the command:
  - `git push origin [tagName]`
  - `ie. git push origin v1.0`

Now, the CI/CD pipeline will do its work!



