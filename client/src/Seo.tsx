import { Helmet } from 'react-helmet';

const SEO = () => {
  const title = 'Minii URL Shortener';

  return (
    <Helmet>
      <title>{title}</title>
      <meta property="og:title" content={title} />
    </Helmet>
  );
};

// eslint-disable-next-line react-refresh/only-export-components
export default SEO;
