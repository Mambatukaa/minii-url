// src/components/NotFound.js
const NotFound = () => {
  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <div className="text-center">
        <h1 className="text-6xl font-bold text-red-500">404</h1>
        <p className="text-2xl mt-4 text-gray-700">Oops! URL not found.</p>
        <p className="text-lg text-gray-500 mt-2">
          The URL you’re looking for doesn’t exist or has been deleted.
        </p>
        <a
          href="/"
          className="mt-6 inline-block px-4 py-2 text-white bg-gray-400 hover:bg-gray-600 rounded"
        >
          Go back to homepage
        </a>
      </div>
    </div>
  );
};

export default NotFound;
