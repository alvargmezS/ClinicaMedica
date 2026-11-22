package Logica;

import java.util.Date;

public class Administrativo extends Persona{

    private int id_administrativo;
    private String sector;
    private Usuario usuarioAdministrativo;

    public Administrativo(int id_persona, String dni, String nombre, String apellido, String direccion,
                          String telefono, Date fecha_nacimiento, int id_administrativo, Usuario usuarioAdministrativo,
                          String sector) {

        super(id_persona, dni, nombre, apellido, direccion, telefono, fecha_nacimiento);
        this.id_administrativo = id_administrativo;
        this.usuarioAdministrativo = usuarioAdministrativo;
        this.sector = sector;
    }

    public int getId_administrativo() {
        return id_administrativo;
    }

    public void setId_administrativo(int id_administrativo) {
        this.id_administrativo = id_administrativo;
    }

    public String getSector() {
        return sector;
    }

    public void setSector(String sector) {
        this.sector = sector;
    }

    public Usuario getUsuarioAdministrativo() {
        return usuarioAdministrativo;
    }

    public void setUsuarioAdministrativo(Usuario usuarioAdministrativo) {
        this.usuarioAdministrativo = usuarioAdministrativo;
    }
}
