package persistence;

import Logica.InformeMedico;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import perisistenceexception.NonexistentEntityException;

import java.io.Serializable;
import java.util.List;

public class InformeMedicoJpaController implements Serializable {

    private EntityManagerFactory emf = null;

    public InformeMedicoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public InformeMedicoJpaController() {
        emf = Persistence.createEntityManagerFactory("clinicaMedica");
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(InformeMedico informe) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(informe);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(InformeMedico informe) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            informe = em.merge(informe);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                int id = informe.getId_informe();
                if (findInformeMedico(id) == null) {
                    throw new NonexistentEntityException("El informe con id " + id + " ya no existe.");
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
            InformeMedico informe;
            try {
                informe = em.getReference(InformeMedico.class, id);
                informe.getId_informe();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("El informe con id " + id + " ya no existe.", enfe);
            }
            em.remove(informe);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<InformeMedico> findInformeMedicoEntities() {
        return findInformeMedicoEntities(true, -1, -1);
    }

    public List<InformeMedico> findInformeMedicoEntities(int maxResults, int firstResult) {
        return findInformeMedicoEntities(false, maxResults, firstResult);
    }

    @SuppressWarnings("unchecked")
    private List<InformeMedico> findInformeMedicoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<InformeMedico> cq = em.getCriteriaBuilder().createQuery(InformeMedico.class);
            cq.select(cq.from(InformeMedico.class));
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

    public InformeMedico findInformeMedico(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(InformeMedico.class, id);
        } finally {
            em.close();
        }
    }

    public int getInformeMedicoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<InformeMedico> rt = cq.from(InformeMedico.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}
