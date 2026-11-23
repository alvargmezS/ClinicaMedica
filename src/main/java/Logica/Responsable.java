package Logica;

import jakarta.persistence.Entity;

import java.util.Date;

@Entity
public class Responsable extends Persona {

    //private int id_responsable;
    private String tipo_responsable;

    public Responsable(int id_persona, String dni, String nombre, String apellido, String direccion, String telefono,
                       Date fecha_nacimiento, Paciente pacienteResponsable,
                       String tipo_responsable) {

        super(id_persona, dni, nombre, apellido, direccion, telefono, fecha_nacimiento);
        //this.id_responsable = id_responsable;
        this.tipo_responsable = tipo_responsable;
    }

    public Responsable() {

    }

    /*public int getId_responsable() {
        return id_responsable;
    }

    public void setId_responsable(int id_responsable) {
        this.id_responsable = id_responsable;
    }*/

    public String getTipo_responsable() {
        return tipo_responsable;
    }

    public void setTipo_responsable(String tipo_responsable) {
        this.tipo_responsable = tipo_responsable;
    }

}
