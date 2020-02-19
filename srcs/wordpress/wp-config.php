<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', "wordpressdb");

/** MySQL database username */
define('DB_USER', "root");

/** MySQL database password */
define('DB_PASSWORD', "password");

/** MySQL hostname */
define('DB_HOST', "mysql");

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'z6X%tnD)sUzHGg++0HpbNVu;GM%QzBOxu-x]Q4^i/y4fmnY^FY-J~|}CAk;8=R;o');
define('SECURE_AUTH_KEY',  '!3AlBlhE5+BA6WuZ bdDpJp4NK+kr1+AV?z?ZqU/-k@.7lGeyx:DR?:~=|E[~A=|');
define('LOGGED_IN_KEY',    'z1kwv8`3:f8*fUoK$q|Ycf2rnC{d+z`b+YE2cB|SN-^(r/o2x`ldfOMh<C|R_/0-');
define('NONCE_KEY',        'W=5D-uMAyp-l_+m*n,(kLEfN>z`-))e(E$y^+:y8E@/IQQ8w@&qI9PTWBt+!HVwL');
define('AUTH_SALT',        '.+p+lFDC0-5_?1Z `ba+ld(~(>B(*$%i%j}t(:10_k,wLb!4QSpr &I+)2TXK,Wa');
define('SECURE_AUTH_SALT', '8PH1-PWwntz.KnOh!2/al+@ael+!._xlB:z#FoAK]p+`GWLYu+%36j+)H>]yGK$>');
define('LOGGED_IN_SALT',   'ky8xJF*~CM4!W/lo86uzw8E8^G|1CgMPjB04u[<BG_LX@at6vSV|Si%KK&f2-?Y+');
define('NONCE_SALT',       'C62w}-.(g<4Ci]d~_|F|~M|RYR8pAQt+~41 LM8+o0)DA!yVxJAuz`QMy0dl/*Xk');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');