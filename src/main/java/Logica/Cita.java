package Logica;

import jakarta.persistence.*;

import java.util.Date;

@Entity
public class Cita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_cita;
    @Temporal(TemporalType.DATE)
    private Date fecha_cita;

    private String hora_cita;
    private String motivo;

    @ManyToOne
    @JoinColumn(name = "id_medico")
    private Medico citaMedico;
    @ManyToOne
    @JoinColumn(name = "id_paciente")
    private Paciente paciente;

    public Cita(int id_cita, Date fecha_cita, String hora_cita, String motivo, Medico citaMedico, Paciente paciente) {
        this.id_cita = id_cita;
        this.fecha_cita = fecha_cita;
        this.hora_cita = hora_cita;
        this.motivo = motivo;
        this.citaMedico = citaMedico;
        this.paciente = paciente;
    }

    public Cita() {

    }

    public int getId_cita() {
        return id_cita;
    }

    public void setId_cita(int id_cita) {
        this.id_cita = id_cita;
    }

    public Date getFecha_cita() {
        return fecha_cita;
    }

    public void setFecha_cita(Date fecha_cita) {
        this.fecha_cita = fecha_cita;
    }

    public String getHora_cita() {
        return hora_cita;
    }

    public void setHora_cita(String hora_cita) {
        this.hora_cita = hora_cita;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public Medico getCitaMedico() {
        return citaMedico;
    }

    public void setCitaMedico(Medico citaMedico) {
        this.citaMedico = citaMedico;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }
}
