import { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';

export default function RedirectHandler() {
  const apiUrl = import.meta.env.VITE_REACT_APP_API_URL;
  const { id } = useParams();

  useEffect(() => {
    axios
      .get(`${apiUrl}/${id}`)
      .then(({ data }) => {
        window.location.href = data;
      })
      .catch(error => {
        console.log(error);
        return <div>Page not found.</div>;
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return null;
}
