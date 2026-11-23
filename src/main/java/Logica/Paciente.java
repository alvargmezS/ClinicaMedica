package Logica;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;

import java.util.Date;
import java.util.List;

@Entity
public class Paciente extends Persona{

    //private int id_paciente;
    private String seguro_medico;
    private String grupo_sangre;

    //Relaciones con el resto de clases
    @OneToOne
    @JoinColumn(name = "responsable_id_persona")
    private Responsable responsable;

    @OneToMany(mappedBy = "paciente")
    private List<Cita> listaCitas;

    public Paciente(int id_persona, String dni, String nombre, String apellido, String direccion, String telefono,
                    Date fecha_nacimiento,  List<Cita> listaCitas, Responsable responsable,
                    String grupo_sangre, String seguro_medico) {

        super(id_persona, dni, nombre, apellido, direccion, telefono, fecha_nacimiento);
        //this.id_paciente = id_paciente;
        this.listaCitas = listaCitas;
        this.responsable = responsable;
        this.grupo_sangre = grupo_sangre;
        this.seguro_medico = seguro_medico;
    }

    public Paciente() {

    }

    public Responsable getResponsable() {
        return responsable;
    }

    public void setResponsable(Responsable responsable) {
        this.responsable = responsable;
    }

    public List<Cita> getListaCitas() {
        return listaCitas;
    }

    public void setListaCitas(List<Cita> listaCitas) {
        this.listaCitas = listaCitas;
    }

    /*public int getId_paciente() {
        return id_paciente;
    }

    public void setId_paciente(int id_paciente) {
        this.id_paciente = id_paciente;
    }*/

    public String getSeguro_medico() {
        return seguro_medico;
    }

    public void setSeguro_medico(String seguro_medico) {
        this.seguro_medico = seguro_medico;
    }

    public String getGrupo_sangre() {
        return grupo_sangre;
    }

    public void setGrupo_sangre(String grupo_sangre) {
        this.grupo_sangre = grupo_sangre;
    }
}
