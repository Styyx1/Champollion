set_project("Champollion")
set_version("1.3.2")
set_languages("cxx20")

add_rules("mode.debug", "mode.release")
add_requires("boost", {configs = {program_options = true}})
add_requires("fmt")

option("build_exe")
    set_default(false)
    set_showmenu(true)
    set_description("Build the Champollion command-line executable")

option("kind")
    set_default("static")
    set_showmenu(true)
    set_description("Library type (static or shared)")
    set_values("static", "shared")



target("Pex")
    set_kind("$(kind)")
    add_files("Pex/*.cpp")
    add_headerfiles("(Pex/*.hpp)")
    add_includedirs(".", {public = true})

target("Decompiler")
    set_kind("$(kind)")
    add_files("Decompiler/*.cpp", "Decompiler/Node/*.cpp")
    add_headerfiles("(Decompiler/*.hpp)", "(Decompiler/Node/*.hpp)")
    add_includedirs(".", {public = true})
    add_deps("Pex")

if has_config("build_exe") then
    target("Champollion")
        set_kind("binary")
        add_files("Champollion/main.cpp")
        add_includedirs(".", "Champollion")
        add_deps("Decompiler", "Pex")
        add_packages("fmt")
        add_links("boost_program_options")

        if is_plat("windows") then
            add_defines("_CRT_SECURE_NO_WARNINGS")
        end
end