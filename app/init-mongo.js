db.getSiblingDB("admin").auth(
	process.env.MONGO_ROOT_USERNAME,
	process.env.MONGO_ROOT_PASSWORD
);

db.createUser({
	user: process.env.MONGO_USERNAME,
	pwd: process.env.MONGO_PASSWORD,
	roles: [{ role: "readWrite", db: process.env.MONGO_DATABASE }]
});
