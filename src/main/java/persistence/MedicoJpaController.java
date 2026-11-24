package persistence;

import Logica.Medico;
import jakarta.persistence.EntityManager;
import jakarta.persistence.*;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.Query;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import perisistenceexception.NonexistentEntityException;

import java.io.Serializable;
import java.util.List;


public class MedicoJpaController implements Serializable {

    private EntityManagerFactory emf = null;

    public MedicoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public MedicoJpaController() {

        emf = Persistence.createEntityManagerFactory("clinicaMedica");
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Medico medico) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(medico);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Medico medico) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            medico = em.merge(medico);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                int id = medico.getId_persona();
                if (findMedico(id) == null) {
                    throw new NonexistentEntityException("The " + "medico" + " with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(int id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Medico medico;
            try {
                medico = em.getReference(Medico.class, id);
                medico.getId_persona();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The " + "medico" + " with id " + id + " no longer exists.", enfe);
            }
            em.remove(medico);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Medico> findMedicoEntities() {
        return findMedicoEntities(true, -1, -1);
    }

    public List<Medico> findMedicoEntities(int maxResults, int firstResult) {
        return findMedicoEntities(false, maxResults, firstResult);
    }

    @SuppressWarnings("unchecked")
    private List<Medico> findMedicoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Medico> cq = em.getCriteriaBuilder().createQuery(Medico.class);
            cq.select(cq.from(Medico.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Medico findMedico(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Medico.class, id);
        } finally {
            em.close();
        }
    }

    public int getMedicoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<Medico> rt = cq.from(Medico.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}