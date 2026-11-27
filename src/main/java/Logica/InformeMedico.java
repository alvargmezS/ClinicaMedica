package Logica;

import jakarta.persistence.*;
import java.util.Date;

@Entity
public class InformeMedico {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_informe;

    @Temporal(TemporalType.TIMESTAMP)
    private Date fecha_informe;

    private String motivo_consulta;

    @Column(columnDefinition = "TEXT")
    private String diagnostico;

    @Column(columnDefinition = "TEXT")
    private String tratamiento;

    @Column(columnDefinition = "TEXT")
    private String observaciones;

    @ManyToOne
    @JoinColumn(name = "id_paciente")
    private Paciente paciente;

    @ManyToOne
    @JoinColumn(name = "id_medico")
    private Medico medico;

    public InformeMedico() {
    }

    public InformeMedico(int id_informe, Date fecha_informe, String motivo_consulta, String diagnostico,
                         String tratamiento, String observaciones, Paciente paciente, Medico medico) {
        this.id_informe = id_informe;
        this.fecha_informe = fecha_informe;
        this.motivo_consulta = motivo_consulta;
        this.diagnostico = diagnostico;
        this.tratamiento = tratamiento;
        this.observaciones = observaciones;
        this.paciente = paciente;
        this.medico = medico;
    }

    public int getId_informe() {
        return id_informe;
    }

    public void setId_informe(int id_informe) {
        this.id_informe = id_informe;
    }

    public Date getFecha_informe() {
        return fecha_informe;
    }

    public void setFecha_informe(Date fecha_informe) {
        this.fecha_informe = fecha_informe;
    }

    public String getMotivo_consulta() {
        return motivo_consulta;
    }

    public void setMotivo_consulta(String motivo_consulta) {
        this.motivo_consulta = motivo_consulta;
    }

    public String getDiagnostico() {
        return diagnostico;
    }

    public void setDiagnostico(String diagnostico) {
        this.diagnostico = diagnostico;
    }

    public String getTratamiento() {
        return tratamiento;
    }

    public void setTratamiento(String tratamiento) {
        this.tratamiento = tratamiento;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public Medico getMedico() {
        return medico;
    }

    public void setMedico(Medico medico) {
        this.medico = medico;
    }
}
