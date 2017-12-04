local user = {}

local keychain = require("plugin.keychain")


user.id = keychain.get("id")
user.name = keychain.get("name")
user.email = keychain.get("email")
user.age = keychain.get("age")
user.avatarFilename = keychain.get("avatarFilename")


user.isLoggedIn = function()
	return (user.id ~= nil)
end


user.new = function(id, name, email, age, gender)
	user.id = id
	user.name = name
	user.email = email
	user.age = age

	keychain.set("id", id)
	keychain.set("name", name)
	keychain.set("email", email)
	keychain.set("age", age)
end


user.saveAvatarFilename = function(filename)
	keychain.set("avatarFilename", filename)
	user.avatarFilename = filename
end


user.logout = function()

	user.email = nil
	user.name = nil
	user.age = nil
	user.id = nil
	user.avatarFilename = nil

	keychain.set("email", nil)
	keychain.set("name", nil)
	keychain.set("age", nil)
	keychain.set("id", nil)
	keychain.set("avatarFilename", nil)

	_G.STORAGE.setWeightData({})
	_G.STORAGE.setFoodData({})

	_G.TABBAR.hide(true)
	require("composer").gotoScene("scene-welcome", { effect="slideRight", time=400})
end




return user