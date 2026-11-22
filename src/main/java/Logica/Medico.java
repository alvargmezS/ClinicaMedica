package Logica;

import java.util.Date;
import java.util.List;

public class Medico extends Persona{

    private int id_medico;
    private String especialidad;

    private List<Cita> citas;
    private Usuario usuarioMedico;
    private Horario horarioMedico;

    public Medico(int id_persona, String dni, String nombre, String apellido, String direccion, String telefono,
                  Date fecha_nacimiento, int id_medico, Horario horarioMedico, Usuario usuarioMedico,
                  List<Cita> citas, String especialidad) {

        super(id_persona, dni, nombre, apellido, direccion, telefono, fecha_nacimiento);
        this.id_medico = id_medico;
        this.horarioMedico = horarioMedico;
        this.usuarioMedico = usuarioMedico;
        this.citas = citas;
        this.especialidad = especialidad;
    }

    public List<Cita> getCitas() {
        return citas;
    }

    public void setCitas(List<Cita> citas) {
        this.citas = citas;
    }

    public Usuario getUsuarioMedico() {
        return usuarioMedico;
    }

    public void setUsuarioMedico(Usuario usuarioMedico) {
        this.usuarioMedico = usuarioMedico;
    }

    public Horario getHorarioMedico() {
        return horarioMedico;
    }

    public void setHorarioMedico(Horario horarioMedico) {
        this.horarioMedico = horarioMedico;
    }

    public int getId_medico() {
        return id_medico;
    }

    public void setId_medico(int id_medico) {
        this.id_medico = id_medico;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }
}
