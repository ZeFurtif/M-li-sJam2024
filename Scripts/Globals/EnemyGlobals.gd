extends Node

var movement_speed = 60
var type = ["enemy_tank", "enemy_speeder", "va_te_faire_elliot_je_sais_plus_quoi_mettre_ptn_de_merde"]

func who_are_you():
	match type:
		{}:
			print("Empty")
		"enemy_tank":
			print("its enemy_tank name")
		"enemy_speeder":
			print("its falsh_mcqueen name")
