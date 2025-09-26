import { useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import api from "../api/axios";
import { AuthContext } from "../components/AuthContext";
import "../styles/Login.css";

function Login() {
  const [form, setForm] = useState({ username: "", password: "" });
  const navigate = useNavigate();
  const { login } = useContext(AuthContext);

  const handleChange = (e) =>
    setForm({ ...form, [e.target.name]: e.target.value });

  const handleLogin = async () => {
    try {
      const res = await api.post("/login", form);
      login(res.data.username, res.data.user_type);
      navigate("/");
    } catch (err) {
      alert(err.response?.data?.message || "Error al iniciar sesión");
    }
  };

  return (
    <div className="login-container">
      <form className="login-form">
        <h2>Iniciar Sesión</h2>
        <input
          name="username"
          onChange={handleChange}
          placeholder="Usuario"
          required
        />
        <input
          name="password"
          type="password"
          onChange={handleChange}
          placeholder="Contraseña"
          required
        />
        <button type="button" onClick={handleLogin}>
          Ingresar
        </button>
        <p className="register-link">
          ¿No tienes cuenta? <a href="/registro">Regístrate</a>
        </p>
      </form>
    </div>
  );
}

export default Login;
