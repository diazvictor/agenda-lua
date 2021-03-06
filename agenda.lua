#!/usr/bin/env lua5.1

--Lalibreria middleclassme da soporte a OOP
require('lib.middleclass')
--En lib/funciones guardare todas las funciones generales
funcion = require('lib.funciones')
-- Similar a funciones pero mas comun
comun = require('lib.comun')
-- La super libreria para el acceso a sqlite
db = require('lib.db')
-- La libreria que me permitirausar GTK
local lgi = require 'lgi'
-- Parte de lgi
local GObject = lgi.GObject
-- para el treeview
local GLib = lgi.GLib
-- El objeto GTK
local Gtk = lgi.require('Gtk', '3.0')

local assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('agenda.ui'))
local ui = builder.objects

local login_window = ui.dialog_login
local main_window = ui.main_window

-- Invoco el objeto btn_cancel de agenda.ui
local btn_cancel = builder:get_object('btn_cancel')
-- Invoco el objeto btn_ok de agenda.ui
local btn_ok = builder:get_object('btn_ok')

-- Invoco el objeto entry_user de agenda.ui
local input = builder:get_object('entry_user')
-- Invoco el objeto entry_password de agenda.ui
local password = builder:get_object('entry_password')

function btn_ok:on_clicked()
	db:open()
	local sql = "select id_usuarios from usuarios where usuario = '"..input.text.."' and contrasena = '"..password.text.."'"
	local result = db:get_var(sql)
	if result then
		print("Bienvenidos")
		login_window:hide()
		main_window:show_all()
	else
		print('contraseña o usuario incorrecto')
	end
end

-- Invoco el objeto btn_add de agenda.ui
local btn_add = builder:get_object('btn_registrar')
-- Invoco el objeto btn_reset de agenda.ui
local btn_reset = builder:get_object('btn_reset')

local function poblar_lista()
	db:open()
	local lista_contactos = builder:get_object('lista_contactos')
	lista_contactos:clear()
	local sql = "select * from contactos order by id_contactos desc"
	local consulta = db:get_results(sql)

	for i,item in pairs(consulta) do
		lista_contactos:append({
			item.id_contactos,
			item.nombre,
			item.numero,
			item.lugar,
			item.fecha_registro
		})
	end
end

poblar_lista()

-- Invoco el objeto entry_nombre de agenda.ui
local input_nombre = builder:get_object('entry_nombre')
-- Invoco el objeto entry_password de agenda.ui
local input_numero = builder:get_object('entry_numero')
-- Invoco el objeto entry_lugar de agenda.ui
local input_lugar = builder:get_object('entry_lugar')

local function insert_data()
	db:open()
	local sql = "insert into contactos(nombre,numero,lugar) values('"..input_nombre.text.."','"..input_numero.text.."','"..input_lugar.text .."')"
	local _numero = tonumber(input_numero.text)
	if input_nombre ~= "" and _numero ~= "" and input_lugar.text ~= "" then
		if (db:query(sql) == false) then
			print("error al insertar los datos")
			print(sql)
		else
			poblar_lista()
			input_numero.text = ""
			input_nombre.text = ""
			input_lugar.text = ""
		end
	else
		print("error campos vacios")
	end
end

function btn_add:on_clicked()
	insert_data()
end


function btn_cancel:on_clicked()
	Gtk.main_quit()
end

-- que hacer cuando le den cerrar a la ventana
function login_window:on_destroy()
	Gtk.main_quit()
end

function main_window:on_destroy()
	Gtk.main_quit()
end

-- Show window and start the loop.
login_window:show_all()
Gtk.main()
