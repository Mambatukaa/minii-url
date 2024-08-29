import { Helmet } from 'react-helmet';

const SEO = () => {
  const title = 'Minii URL Shortener';
  const description = 'A simple URL shortener';
  const imageUrl = '../assets/images/og.png';

  return (
    <Helmet>
      <title>{title}</title>
      <meta property="og:type" content="article" />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={imageUrl} />
    </Helmet>
  );
};

// eslint-disable-next-line react-refresh/only-export-components
export default SEO;
