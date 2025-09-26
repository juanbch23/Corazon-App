import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import api from "../api/axios";
import "../styles/AdminDiagnosticos.css";

function AdminDiagnosticos() {
  const { paciente_id } = useParams();
  const [diagnosticos, setDiagnosticos] = useState([]);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await api.get(`/admin/diagnosticos/${paciente_id}`);
        setDiagnosticos(res.data || []);
      } catch (err) {
        console.error("Error al cargar el historial:", err);
        setError("No se pudo cargar el historial del paciente.");
      }
    };
    fetchData();
  }, [paciente_id]);

  const formatFecha = (fechaStr) => {
    const fecha = new Date(fechaStr);
    return fecha.toLocaleString();
  };

  const obtenerNivelRiesgo = (r) =>
    r === 0 ? "Bajo" : r === 1 ? "Medio" : "Alto";

  return (
    <div className="container">
      <h2>Historial de Diagnósticos</h2>
      {error && <div className="message-box error">{error}</div>}
      {!error && diagnosticos.length === 0 && (
        <div className="message-box">No hay diagnósticos registrados.</div>
      )}
      {diagnosticos.length > 0 && (
        <table className="table">
          <thead>
            <tr>
              <th>Fecha</th>
              <th>P. Sistólica</th>
              <th>P. Diastólica</th>
              <th>Colesterol</th>
              <th>Glucosa</th>
              <th>Actividad</th>
              <th>Peso</th>
              <th>Estatura</th>
              <th>Riesgo</th>
              <th>Confianza</th>
            </tr>
          </thead>
          <tbody>
            {diagnosticos.map((d, idx) => (
              <tr key={idx}>
                <td>{formatFecha(d.fecha_diagnostico)}</td>
                <td>{d.ps}</td>
                <td>{d.pd}</td>
                <td>{d.colesterol}</td>
                <td>{d.glucosa}</td>
                <td>{d.actividad}</td>
                <td>{d.peso} kg</td>
                <td>{d.estatura} cm</td>
                <td>{obtenerNivelRiesgo(d.riesgo)}</td>
                <td>{(d.confianza * 100).toFixed(2)}%</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}

      <button className="btn btn-secondary" onClick={() => navigate("/admin")}>
        Volver
      </button>
    </div>
  );
}

export default AdminDiagnosticos;
