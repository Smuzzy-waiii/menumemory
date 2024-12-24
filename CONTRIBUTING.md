# Contributing Guidelines

1. Please fork this repo (acmpesuecc/Onyx) to your own account and work on your fork of this repo.
2. Create a PR from your fork to this repo (remember to reference the correct issue in your PR)

**Please contact me at +91 8618950413 to get Firebase and/or Algolia access for this project**

# Architecture 
Menumemory uses Firebase as its backend. It uses cloud firestore as the db, FB Auth for auth and cloud functions as of right now. The Algolia FB extension is installed for search

There are 2 top level collections in firestore as of right now: `restraurants` and `users`. 
- Every doc in the `restaurants` collection correlates to one restaurant. There is an Algolia index on the `restaurants` collection to allow searching restaurants in the future.
- Every doc in the `users` collection correlates to one user. This doc is auto-created by the `onUserSignUp` cloud function whenever a new user is created in firebase auth.
- There is a `visits` collection under /users/<user_id>/ Each doc in this `visits` collection stores the details of one particular restaurant visit for that user.
