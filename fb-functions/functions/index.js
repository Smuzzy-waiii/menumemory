const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Trigger that listens to new user sign-ups
exports.onUserSignUp = functions.auth.user().onCreate((user) => {
  const userId = user.uid;
  const email = user.email;
  const displayName = user.displayName || "Anonymous"; //TODO: remove this

  // Document to add to the "users" collection
  const userDoc = {
    uid: userId,
    email: email,
    displayName: displayName, //TODO: remove this
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  };

  // Add the document to Firestore
  return admin.firestore().collection("users").doc(userId).set(userDoc)
    .then(() => {
      console.log(`User ${userId} added to Firestore`);
    })
    .catch((error) => {
      console.error("Error adding user to Firestore: ", error);
    });
});

